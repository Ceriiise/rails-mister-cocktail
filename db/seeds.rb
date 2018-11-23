require 'json'
require 'open-uri'

puts 'DB Destroy ----------'
Dose.destroy_all
Cocktail.destroy_all
Ingredient.destroy_all
puts 'Done!'


puts 'Creating Ingredients...'

url = "https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list"
user_serialized = open(url).read
result = JSON.parse(user_serialized)
  result['drinks'].each do |item|
    Ingredient.create!(name: item["strIngredient1"])
    # p item['strIngredient1']
  end

puts 'Done!!'
puts 'Creating Cocktails & Doses...'

  cocktails_url = Array.new
  url = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail"
  user_serialized = open(url).read
  result = JSON.parse(user_serialized)
    result['drinks'].each do |item|
      cocktail_url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{item["idDrink"]}"
      cocktails_url << cocktail_url
    end

  cocktails_url.each do |url|
    cocktail_ingredients = []
    user_serialized = open(url).read
    result = JSON.parse(user_serialized)
      cocktail = Cocktail.new(name: result['drinks'][0]['strDrink'])
      cocktail.description = result['drinks'][0]['strInstructions']
      cocktail.image_url = result['drinks'][0]["strDrinkThumb"]
      result['drinks'][0].each do |item|
        if (/strIngredient/).match?(item[0])
          cocktail_ingredients << item[1]
        end
      end

    cocktail_ingredients.reject!(&:blank?).each do |ingredient|
      if Ingredient.where(name: ingredient).count == 1
        i = cocktail_ingredients.find_index(ingredient)
        dose = Dose.new(description: result['drinks'][0]["strMeasure#{i+1}"])
        dose.ingredient_id = Ingredient.where(name: ingredient).first.id
        dose.cocktail = cocktail
        dose.save
      else
        new_ingredient = Ingredient.create!(name: ingredient)
        i = cocktail_ingredients.find_index(ingredient)
        dose = Dose.new(description: result['drinks'][0]["strMeasure#{i+1}"])
        dose.ingredient_id = Ingredient.where(name: ingredient).first.id
        dose.cocktail = cocktail
        dose.save
      end
    end
  end

puts 'Done!!!'
