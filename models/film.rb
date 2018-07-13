require_relative('../db/sql_runner')
class Film
  attr_accessor :title, :price
  attr_reader :id
  def initialize(options)
    @title = options['title']
    @price = options['price'].to_i
    @id = options['id'].to_i
  end

  def save
    sql = "INSERT INTO films (title, price)
        VALUES ($1, $2)
        RETURNING id;"
    values = [@title, @price]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.find_all
    sql = "SELECT * FROM films"
    result = SqlRunner.run(sql)
    return result.map { |film| Film.new(film) }
  end

  def self.find(id)
    sql = "SELECT * FROM films
        WHERE id = $1;"
    values = [id]
    result = SqlRunner.run(sql, values)[0]
    return Film.new(result)
  end

  def update
    sql = "UPDATE films SET (title, price) = ($1, $2)
    WHERE id=$3;"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def customers
    sql = "SELECT customers.*
        FROM customers
        INNER JOIN tickets
        ON customers.id = tickets.customer_id
        WHERE tickets.film_id = $1"
    values = [@id]
    customers = SqlRunner.run(sql,values)
    return customers.map { |customer| Customer.new(customer) }
  end

end
