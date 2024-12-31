;; clarity-scientific-papers
;; Scientific Paper Management and Access Control
;; 
;; This Clarity smart contract enables decentralized management of scientific paper submissions and access control. 
;; It allows users to add, update, transfer ownership, and delete research papers while ensuring data integrity. 
;; Access control mechanisms provide authors and authorized readers with appropriate permissions. 
;; Key features include gas-optimized retrieval of paper details, validation of metadata, and UI-friendly data views. 
;; Manages scientific paper submissions and access control

;; Constants and Error Codes
(define-constant ADMIN tx-sender)
(define-constant ERR_ADMIN_ONLY (err u300))
(define-constant ERR_PAPER_NOT_FOUND (err u301))
(define-constant ERR_DUPLICATE_PAPER (err u302))
(define-constant ERR_INVALID_TITLE (err u303))
(define-constant ERR_INVALID_SIZE (err u304))
(define-constant ERR_ACCESS_DENIED (err u305))

;; Data Variables
(define-data-var paper-count uint u0)

;; Data Maps
(define-map research-papers
  { paper-id: uint }
  {
    paper-title: (string-ascii 80),
    paper-author: principal,
    paper-size: uint,
    date-published: uint,
    paper-abstract: (string-ascii 256),
    paper-keywords: (list 8 (string-ascii 40))
  }
)

(define-map reader-access
  { paper-id: uint, reader: principal }
  { access-granted: bool }
)

;; Helper Functions
(define-private (is-paper-existing (paper-id uint))
  (is-some (map-get? research-papers { paper-id: paper-id }))
)

(define-private (is-author (paper-id uint) (author principal))
  (match (map-get? research-papers { paper-id: paper-id })
    paper-details (is-eq (get paper-author paper-details) author)
    false
  )
)

(define-private (get-paper-size (paper-id uint))
  (default-to u0 
    (get paper-size 
      (map-get? research-papers { paper-id: paper-id })
    )
  )
)

;; Validation Functions
(define-private (validate-keyword (keyword (string-ascii 40)))
  (and 
    (> (len keyword) u0)
    (< (len keyword) u41)
  )
)

(define-private (validate-keywords (keywords (list 8 (string-ascii 40))))
  (and
    (> (len keywords) u0)
    (<= (len keywords) u8)
    (is-eq (len (filter validate-keyword keywords)) (len keywords))
  )
)

;; Public Functions - Paper Management

;; Add new research paper
(define-public (add-paper (title (string-ascii 80)) (size uint) (abstract (string-ascii 256)) (keywords (list 8 (string-ascii 40))))
  (let
    (
      (paper-id (+ (var-get paper-count) u1))
    )
    (asserts! (> (len title) u0) ERR_INVALID_TITLE)
    (asserts! (< (len title) u81) ERR_INVALID_TITLE)
    (asserts! (> size u0) ERR_INVALID_SIZE)
    (asserts! (< size u2000000000) ERR_INVALID_SIZE)
    (asserts! (> (len abstract) u0) ERR_INVALID_TITLE)
    (asserts! (< (len abstract) u257) ERR_INVALID_TITLE)
    (asserts! (validate-keywords keywords) ERR_INVALID_TITLE)

    (map-insert research-papers
      { paper-id: paper-id }
      {
        paper-title: title,
        paper-author: tx-sender,
        paper-size: size,
        date-published: block-height,
        paper-abstract: abstract,
        paper-keywords: keywords
      }
    )

    (map-insert reader-access
      { paper-id: paper-id, reader: tx-sender }
      { access-granted: true }
    )
    (var-set paper-count paper-id)
    (ok paper-id)
  )
)

;; Transfer paper ownership
(define-public (transfer-ownership (paper-id uint) (new-author principal))
  (let
    (
      (paper-details (unwrap! (map-get? research-papers { paper-id: paper-id }) ERR_PAPER_NOT_FOUND))
    )
    (asserts! (is-paper-existing paper-id) ERR_PAPER_NOT_FOUND)
    (asserts! (is-eq (get paper-author paper-details) tx-sender) ERR_ACCESS_DENIED)

    (map-set research-papers
      { paper-id: paper-id }
      (merge paper-details { paper-author: new-author })
    )
    (ok true)
  )
)

;; Update paper details
(define-public (update-paper (paper-id uint) (new-title (string-ascii 80)) (new-size uint) (new-abstract (string-ascii 256)) (new-keywords (list 8 (string-ascii 40))))
  (let
    (
      (paper-details (unwrap! (map-get? research-papers { paper-id: paper-id }) ERR_PAPER_NOT_FOUND))
    )
    (asserts! (is-paper-existing paper-id) ERR_PAPER_NOT_FOUND)
    (asserts! (is-eq (get paper-author paper-details) tx-sender) ERR_ACCESS_DENIED)
    (asserts! (> (len new-title) u0) ERR_INVALID_TITLE)
    (asserts! (< (len new-title) u81) ERR_INVALID_TITLE)
    (asserts! (> new-size u0) ERR_INVALID_SIZE)
    (asserts! (< new-size u2000000000) ERR_INVALID_SIZE)
    (asserts! (> (len new-abstract) u0) ERR_INVALID_TITLE)
    (asserts! (< (len new-abstract) u257) ERR_INVALID_TITLE)
    (asserts! (validate-keywords new-keywords) ERR_INVALID_TITLE)

    (map-set research-papers
      { paper-id: paper-id }
      (merge paper-details { 
        paper-title: new-title, 
        paper-size: new-size, 
        paper-abstract: new-abstract, 
        paper-keywords: new-keywords 
      })
    )
    (ok true)
  )
)

;; Delete paper
(define-public (delete-paper (paper-id uint))
  (let
    (
      (paper-details (unwrap! (map-get? research-papers { paper-id: paper-id }) ERR_PAPER_NOT_FOUND))
    )
    (asserts! (is-paper-existing paper-id) ERR_PAPER_NOT_FOUND)
    (asserts! (is-eq (get paper-author paper-details) tx-sender) ERR_ACCESS_DENIED)

    (map-delete research-papers { paper-id: paper-id })
    (ok true)
  )
)

