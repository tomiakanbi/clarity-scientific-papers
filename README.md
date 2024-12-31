# Clarity Scientific Papers

**Scientific Paper Management and Access Control on Blockchain**

## Overview

This repository contains the `clarity-scientific-papers` smart contract, written in Clarity, to manage scientific paper submissions and access control in a decentralized, transparent, and immutable manner. It empowers authors with ownership over their work while maintaining robust access control for readers.

### Key Features
- **Paper Submission:** Authors can submit research papers with metadata such as title, abstract, keywords, and publication date.
- **Ownership Transfer:** Facilitates the transfer of paper ownership between authors.
- **Access Control:** Ensures that only authorized readers have access to the papers.
- **Gas-Optimized Functions:** Provides gas-efficient retrieval and management of paper data.
- **Data Validation:** Validates metadata to maintain data integrity.
- **UI-Friendly Views:** Includes functions for creating user-friendly displays of paper details.

---

## Contract Details

### Constants and Error Codes
- `ADMIN`: The contract administrator (default is the transaction sender).
- Error Codes:
  - `ERR_ADMIN_ONLY` (u300): Unauthorized access.
  - `ERR_PAPER_NOT_FOUND` (u301): Paper not found.
  - `ERR_DUPLICATE_PAPER` (u302): Duplicate paper detected.
  - `ERR_INVALID_TITLE` (u303): Invalid title or metadata.
  - `ERR_INVALID_SIZE` (u304): Invalid paper size.
  - `ERR_ACCESS_DENIED` (u305): Access denied to the requested resource.

### Data Structures
- **Global Variables**
  - `paper-count`: Tracks the total number of papers added.
- **Data Maps**
  - `research-papers`: Stores details of each research paper (title, author, size, abstract, keywords, etc.).
  - `reader-access`: Maps reader permissions for specific papers.

---

## Public Functions

### Paper Management
- **Add Paper:** `add-paper(title, size, abstract, keywords)`  
  Submits a new research paper with metadata and assigns ownership to the author.

- **Transfer Ownership:** `transfer-ownership(paper-id, new-author)`  
  Transfers the ownership of a research paper to another principal.

- **Update Paper:** `update-paper(paper-id, new-title, new-size, new-abstract, new-keywords)`  
  Updates the details of an existing research paper.

- **Delete Paper:** `delete-paper(paper-id)`  
  Removes a paper from the system, ensuring only the owner can delete it.

### Optimized Retrieval
- **Get Paper Details (Optimized):** `get-paper-details-optimized(paper-id)`  
  Retrieves essential details of a paper, such as title, author, and size, minimizing gas costs.

- **Paper Summary:** `get-paper-summary(paper-id)`  
  Returns a brief summary of the paper's title and author.

---

## Access Control
- **Reader Access:**  
  Access control is implemented to ensure only authorized readers can view paper details. Ownership automatically grants access to the author.

---

## Development

### Prerequisites
- **Clarity Language:** Ensure you have a working knowledge of Clarity and its development environment.
- **Stack Blockchain:** Deploy and test on the Stacks blockchain.

### Deployment
1. Clone the repository:  
   ```bash
   git clone <repository-url>
   cd clarity-scientific-papers
   ```
2. Deploy the contract using the Stacks CLI or IDE of your choice.

3. Test the contract with predefined functions.

---

## Usage

### Adding a Paper
```clarity
(add-paper "Quantum Computing Basics" u200 "An introduction to quantum computing." ["quantum" "computing" "basics"])
```

### Transferring Ownership
```clarity
(transfer-ownership u1 'SP3FBR2AGK80Y0X4Q0TK0R20W94H4JHW21WDGZ52C)
```

---

## Contributing
We welcome contributions to improve the contract or expand its features. Please open an issue or submit a pull request.

---

## License
This project is licensed under the MIT License. See the LICENSE file for more details.
