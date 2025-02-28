ActiveAdmin.register Serie do
  actions :index, :show # permite apenas visualizar índice e detalhes
  permit_params :nome_br, :nome_original, :pais, :popularidade, :media_votacao, :sinopse, :url_foto


  action_item :importar_series, only: :index do
    link_to 'Importar 10 Séries', importar_series_admin_series_index_path, method: :get
  end

  #action_item :importar_series, only: :show do
  #  link_to 'Ver elenco', importar_series_admin_series_index_path, method: :get
  #end

  

  collection_action :importar_series, method: :get do
    series_importadas = TmdbService.new.importar_series
    redirect_to collection_path, notice: "#{series_importadas} séries foram importadas com sucesso!"
  end

  filter :name_pt
  filter :original_name
  filter :country
  filter :popularity
  filter :average_voting

  index do
    selectable_column
    id_column
    column :name_pt
    column :original_name
    column :country
    column :popularity
    column :average_voting
    column :characters do |serie|
      link_to "Ver elenco", admin_characters_path(q: {serie_id_eq: serie.id})
      end
    actions
  end

  show do
    attributes_table do
      row :name_pt
      row :original_name
      row :country
      row :popularity
      row :average_voting
      row :synopsis
      row :url_photo do |serie|
        image_tag serie.url_photo if serie.url_photo.present?
      end
      row :characters do |serie|
        link_to "Ver elenco", admin_characters_path(q: {serie_id_eq: serie.id})
      end
    end

  end
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
   #permit_params :id_serie, :name_pt, :original_name, :country, :popularity, :average_voting, :synopsis, :url_photo
  #
  # or
  #
  # permit_params do
  #   permitted = [:id_serie, :name_pt, :original_name, :country, :popularity, :average_voting, :synopsis, :url_photo]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
