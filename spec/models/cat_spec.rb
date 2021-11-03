require 'rails_helper'

RSpec.describe Cat, type: :model do
  it 'should have a valid name' do
    cat = Cat.create(age: 3, enjoys: 'being comic relief')
    expect(cat.errors[:name].first).to eq "can't be blank"
  end
  it 'should have a valid age' do
    cat = Cat.create(name: 'Schnarf', enjoys: 'being comic relief')
    expect(cat.errors[:age].first).to eq "can't be blank"
  end
  it 'should have a valid enjoys' do
    cat = Cat.create(name: 'Schnarf', age: 3)
    expect(cat.errors[:enjoys].first).to eq "can't be blank"
  end
  it 'should have an enjoys entry of at least 10 characters' do
    cat = Cat.create(name: 'Schnarf', age: 3, enjoys: 'food')
    expect(cat.errors[:enjoys].first).to eq 'is too short (minimum is 10 characters)'
  end
end
