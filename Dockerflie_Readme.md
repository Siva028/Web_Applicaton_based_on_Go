**Flow Summary**:


***Build Phase***:

Pull Go image
↓
Download deps (cached)
↓
Compile binary (cached)

***Runtime Phase***:

Pull tiny distroless image
↓
Copy only binary + static files
↓
Run app as non-root user


