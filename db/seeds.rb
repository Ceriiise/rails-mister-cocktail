require 'json'
require 'open-uri'

puts 'Cleaning database...'
Cocktail.destroy_all
Ingredient.destroy_all
Dose.destroy_all

#SEED COCKTAILS (NAME & PHOTO)
puts 'Creating COCKTAILS (NAME & PHOTO)...'

url = 'https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail'
file = open(url).read
cocktail_list = JSON.parse(file)

array_cocktails = cocktail_list.values.flatten

array_cocktails.each do |cocktail|
  Cocktail.create(name: cocktail.values.first, photo: cocktail.values.second)

  # FIND COCKTAILS BY ID
  url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{cocktail.values.third}"
  puts url
  # url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=13060"
  file = open(url).read
  cocktail_details = JSON.parse(file)

  array_details = cocktail_details.values.flatten

  array_details.each do |detail|
    # p detail.values.last(31).first
    # p detail.values.last(31).second
    # p detail.values.last(31).third
    # p detail.values.last(31).fourth

    # cocktail_name = detail.values.second

    # SEED INGREDIENTS
    cocktail_ingredients = detail.values.last(31).first(15)
    p cocktail_ingredients

    cocktail_ingredients.each do |ingredient|
      Ingredient.create(name: ingredient)

      # SEED DOSES
      cocktail_doses = detail.values.last(16).first(15)
      cocktail_doses.each do |dose|
        Dose.create(description: dose, ingredient_id: Ingredient.where(name: ingredient))
        # d = Dose.new(description: dose)
        # d.ingredient = Ingredient.where(name: ingredient)
        # d.save
      end
    end
  end
end
