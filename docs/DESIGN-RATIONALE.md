# Design Rationale

## Structural Decisions

### Why Copy is a separate entity, not just a count on Book

Book tracks only catalogue-level information (isbn, title). A
physical copy can be in one of three states: available, on loan,
or held for a specific member who hasn't collected it yet. Counting
copies as a single number on Book cannot express the "held" state,
so each physical copy is modeled as its own entity with its own
status.

### Why MembershipTier is a Strategy, not a plain field

Borrowing rules — loan period, maximum loans, maximum renewals, and
maximum reservations — all vary by tier. A Strategy Pattern lets
each tier class own its own values, so LoanService asks a Member's
tier for the applicable rule rather than branching on tier type
internally.

### Why Money is used for monetary values

Following the brief's guidance (slide 6: "Values: Money, Isbn —
validated once"), fine amounts are represented as a Money value
object rather than a raw number, so currency and validity are
enforced at construction rather than trusted at every call site.

### Why Loan and Reservation carry status rather than being deleted when their work is done

Both records need to remain queryable after their "active" phase
ends:
- A Loan's borrowed_on, due_date, and returned_at are needed by
  Fine calculation for as long as a related Fine exists.
- A Reservation can be in one of two active states — pending (no
  copy assigned) or fulfilled (a copy is held, not yet collected) —
  and R6 requires that either state remain cancellable, closing the
  queue behind the member who leaves it.

Both records use a status field (Loan: active/returned; Reservation:
pending/fulfilled) instead of being removed from the repository, so
one record type can represent the whole lifecycle.

### Why Fine stores loan_id rather than copying loan data

Because Loan records persist, a Fine can look up borrowed_on,
due_date, and returned_at via loan_id whenever needed, instead of
duplicating that data into itself at creation time.

### Why due_date is stored on Loan rather than recalculated from
the member's current tier

A member's tier can change after a loan is created (e.g., upgraded
to Premium). Recalculating due_date from the member's current tier
at query time would let a tier change silently alter a past loan's
terms. Storing due_date at borrow time fixes the rule that applied
when the loan was made.

## Behavioral Decisions

### Why hold expiration is checked lazily rather than via a scheduled job

The project excludes frameworks and background job systems. Instead
of a scheduled process releasing expired holds, borrow() checks and
releases any expired holds for the requested isbn before evaluating
availability. A hold's expiry is therefore only reflected the next
time that book is queried or borrowed, rather than the instant it
lapses — an accepted tradeoff given the constraint. If the queue for
that book still has an eligible waiting member, that member takes
priority over a new, unrelated borrow request; the copy only becomes
freely available if no one in the queue is eligible.

### Why a failed borrow does not automatically create a reservation

Joining the reservation queue is a commitment the member should make
deliberately. If borrow() fails (no available copy, and no copy
already held for this member), it raises an error rather than
silently reserving on the member's behalf; the member calls
reserve() separately if they want to join the queue.

### Why a member cannot hold two active reservations for the same book

Several repository queries (held_copy_for, find_fulfilled_for) look
up a single reservation for a given member and isbn combination,
assuming at most one active (pending or fulfilled) reservation
exists per member per book. Allowing a member to reserve the same
book twice would break this assumption and make it ambiguous which
reservation should be fulfilled when a copy becomes available.
reserve() checks for an existing active reservation for the same
isbn and member before creating a new one.

### Why reserve() does not check for unpaid fines, but borrow() does

Reserving does not commit any library resource — it only records
intent to wait. Borrowing hands over a physical copy, which the
library is entitled to withhold from a member with unpaid fines.
The two operations are checked independently: BorrowingEligibilityPolicy
is consulted by borrow(), never by reserve().

## Catalogue Decisions

### Why Copy has a withdrawn status instead of being deleted from the catalogue

Loan and Fine records reference a copy via copy_id, and those
records persist. If a copy were deleted outright, any loan or fine
referencing it would point at nothing. Withdrawing sets status to
:withdrawn instead, so the copy remains a valid reference while no
longer being available, on loan, or held.

### Why withdrawing a copy is blocked for both on_loan and held copies, not just on_loan

The brief only requires that withdrawing a copy currently on loan
must fail. A held copy has already been promised to a specific
member (via a fulfilled reservation and a notification), even
though they haven't collected it yet. Withdrawing it out from under
them would leave that reservation pointing at a copy that no longer
exists in a usable state. CopyInUseError covers both cases.

### Why CatalogueService does not check who is allowed to withdraw a copy

Authorization — deciding whether the caller is permitted to perform
an admin action — belongs to a boundary layer (a controller, a
policy check, middleware), which this project deliberately excludes
(no UI, no controllers, no framework). CatalogueService assumes its
caller is already authorized; enforcing that assumption is the
responsibility of whatever boundary would sit in front of this
service in a real deployment. This is a deliberate scope boundary,
not an oversight.