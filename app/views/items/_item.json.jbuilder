json.extract! item, :id, :name, :category, :location, :description, :image, :price_ct, :rental_duration_days,
              :rental_start, :return_checklist, :created_at, :updated_at
json.url item_url(item, format: :json)
json.image url_for(item.image)
