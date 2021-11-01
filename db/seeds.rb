cats = [
  {
    id: 1,
    name: "Lion-o",
    age: 5,
    enjoys: "sunshine and warm spots"
  },
  {
    id: 2,
    name: "Cheetara",
    age: 4,
    enjoys: "being queen of the dogs"
  },
  {
    id: 3,
    name: "Panthro",
    age: 1,
    enjoys: "getting all the attention"
  }
]

cats.each do |attributes|
  Cat.create attributes
  puts "creating cat #{attributes}"
end
