json.coupons do
  json.array! @coupons, :id, :name, :code, :status, :discount_value, :due_date
end