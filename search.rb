require 'json'

def load_json file_name
  file = open file_name
  json = file.read
  JSON.parse json
end

def load_entity entity_name
  load_json entity_name.downcase + ".json"
end

def search entity_name, search_term, search_value
  entities = load_entity entity_name
  entities.select do |entity|
    if entity[search_term].class.name == "Array"
      entity[search_term].include? search_value
    else
      entity[search_term].to_s == search_value
    end
  end
end

def spaser max_size, length
  spase = ""
  (0..(max_size - length)).each do
    spase += " "
  end
  spase
end

def print_entities entities
  entities.each do |entity|
    puts
    entity.each do |key, value|
      spases = spaser(20, key.length)
      puts "#{key}#{spases} #{value}"
    end
  end
end

def print_search_fields entity_name
  puts "----------------------------------------"
  puts "Search #{entity_name} with"

  parsed = load_entity entity_name
  parsed[0].keys.each do |key|
    puts key
  end

  puts
end

def search_menu
  puts "Select 1) Users or 2) Tickets or 3) Organizations"
  menu_option = gets.strip

  if menu_option == "1"
    entity_name = "Users"
  elsif menu_option == "2"
    entity_name = "Tickets"
  elsif menu_option == "3"
    entity_name = "Organizations"
  else
    puts "Wrong menu option #{menu_option}"
    return
  end

  puts "Enter search term for #{entity_name}"
  search_term = gets.strip
  puts "Enter search value for #{search_term}"
  search_value = gets.strip

  entities = search entity_name, search_term, search_value
  if entities.length == 0
    puts "Searching #{entity_name} for #{search_term} with a value of #{search_value}"
    puts "No results found"
  else
    print_entities entities
  end
end

def main_menu
  puts "Welcome to Search"
  puts "Type 'quit' to exit at any time, Press 'Enter' to continue"
  menu_option = gets.strip

  until menu_option == "quit" do

    puts ""
    puts "Select search options:"
    puts " * Type 1 to search"
    puts " * Type 2 to view a list of searchable fields"
    puts " * Type 'quit' to exit"
    puts ""

    menu_option = gets.strip

    if menu_option == "1"
      search_menu
    elsif menu_option == "2"
      print_search_fields "Users"
      print_search_fields "Tickets"
      print_search_fields "Organizations"
    end

  end
end

main_menu
