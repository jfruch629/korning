require "pg"
require "csv"
require "pry"

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

employees = []
accounts = []
products = []
CSV.foreach('sales.csv', headers: true) do |row|
  db_connection do |conn|

    if !employees.any? { |employee| employee == row["employee"] }
      employees << row["employee"]
      insert_record_employee = "INSERT INTO employees (employee_with_email) VALUES ($1)"
      values_employees = [row['employee']]
    end

    if !accounts.any? { |account| account == row["customer_and_account_no"] }
      accounts << row["customer_and_account_no"]
      insert_record_accounts = "INSERT INTO accounts (customer_and_account_no,invoice_frequency) VALUES ($1,$2)"
      values_accounts = [row['customer_and_account_no'], row['invoice_frequency']]
    end

    if !products.any? { |product| product == row["product_name"]}
      products << row["product_name"]
      insert_record_products = "INSERT INTO products (product_name) VALUES ($1)"
      values_products = [row["product_name"]]
    end

    if !insert_record_employee.nil?
      conn.exec_params(insert_record_employee, values_employees)
    end

    if !insert_record_accounts.nil?
      conn.exec_params(insert_record_accounts, values_accounts)
    end

    if !insert_record_products.nil?
    conn.exec_params(insert_record_products, values_products)
    end

    employee_id_sql = conn.exec_params('SELECT id FROM employees WHERE employee_with_email=$1', [row['employee']])
    customer_id_sql = conn.exec_params('SELECT id FROM accounts WHERE customer_and_account_no=$1', [row['customer_and_account_no']])
    product_id_sql = conn.exec_params('SELECT id FROM products WHERE product_name=$1', [row['product_name']])

    insert_record_sales = "INSERT INTO sales (employee_id, customer_id, product_id, sale_date,sale_amount,units_sold,invoice_no) VALUES ($1,$2,$3,$4,$5,$6,$7)"
    values_sales = [employee_id_sql[0]["id"], customer_id_sql[0]["id"], product_id_sql[0]["id"], row['sale_date'], row['sale_amount'], row['units_sold'], row['invoice_no']]

    conn.exec_params(insert_record_sales, values_sales)
  end
end
