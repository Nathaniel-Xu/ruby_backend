def does_merge_mutate (hash1,hash2)
  p hash1.merge(hash2)
  p hash1, hash2
  hash1.merge!(hash2)
  p hash1, hash2
end

does_merge_mutate({name: "charlie", age: "huh", yup: "lets"}, {ill: "yes", word: "ok"})
  