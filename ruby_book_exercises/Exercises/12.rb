contact_data = [["joe@email.com", "123 Main st.", "555-123-4567"],
            ["sally@email.com", "404 Not Found Dr.", "123-234-3454"]]

contacts = {"Joe Smith" => {}, "Sally Johnson" => {}}

def copy_data (data, store)
  data_type = [:email, :address, :number]
  keys = store.keys
  for num1 in 0..1
    for num2 in 0..2
      store[keys[num1]][data_type[num2]] = data[num1][num2] 
    end
  end
  store
end

contacts = copy_data(contact_data, contacts)
p contacts["Joe Smith"] [:email]
p contacts["Sally Johnson"] [:number]