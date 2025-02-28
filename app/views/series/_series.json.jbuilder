json.extract! series, :id, :id_serie, :name_pt, :original_name, :country, :popularity, :average_voting, :synopsis, :url_photo, :created_at, :updated_at
json.url series_url(series, format: :json)
