require_relative('../db/sql_runner')
class Customer
  attr_accessor :name, :funds
  attr_reader :id
  def initialize(options)
    @name = options['name']
    @funds = options['funds'].to_i
    @id = options['id'].to_i
  end

  def save
    sql = "INSERT INTO customers (name, funds)
        VALUES ($1, $2)
        RETURNING id"
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.find_all
    sql = "SELECT * FROM customers"
    result = SqlRunner.run(sql)
    return result.map { |customer| Customer.new(customer) }
  end

  def self.find(id)
    sql = "SELECT * FROM customers
        WHERE id = $1;"
    values = [id]
    result = SqlRunner.run(sql, values)[0]
    return Customer.new(result)
  end

  def update
    sql = "UPDATE customers SET (name, funds) = ($1, $2)
    WHERE id=$3;"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def films
    sql = "SELECT films.*
        FROM films
        INNER JOIN tickets
        ON films.id = tickets.film_id
        WHERE tickets.customer_id = $1"
    values = [@id]
    films = SqlRunner.run(sql,values)
    return films.map { |film| Film.new(film) }
  end

end
