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
