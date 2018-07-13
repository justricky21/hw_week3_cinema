require_relative('../db/sql_runner')
class Ticket
  attr_accessor :customer_id, :film_id
  attr_reader :id
  def initialize(options)
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i
    @id = options['id'].to_i
  end

  def save
    sql = "INSERT INTO tickets (customer_id, film_id)
        VALUES ($1, $2)
        RETURNING id;"
    values = [@customer_id, @film_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i
  end

  def self.find_all
    sql = "SELECT * FROM tickets"
    result = SqlRunner.run(sql)
    return result.map { |ticket| Ticket.new(ticket) }
  end

  def self.find(id)
    sql = "SELECT * FROM tickets
        WHERE id = $1;"
    values = [id]
    result = SqlRunner.run(sql, values)[0]
    return Ticket.new(result)
  end

  def update
    sql = "UPDATE tickets SET (customer_id, film_id) = ($1, $2)
    WHERE id=$3;"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

end
