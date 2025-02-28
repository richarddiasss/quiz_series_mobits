ActiveAdmin.register Character do
  #belongs_to :serie  #param: :series_id   # Isso faz com que Character só seja acessível via Serie
  actions :index, :show # permite apenas visualizar índice e detalhes
  menu false
  permit_params :name, :serie_id, :url_photo, :actor_name, :character_name

  remove_filter :serie
  remove_filter :actor_name
  remove_filter :character_name
  remove_filter :url_photo
  remove_filter :created_at
  remove_filter :updated_at
  index do 
    column :url_photo do |character|
      character.url_photo.present? ? image_tag(character.url_photo) : "Não tem foto"

    end
    column :actor_name
    column :character_name

  end
  
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  #permit_params :actor_name, :character_name, :url_photo, :serie_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:actor_name, :character_name, :url_photo, :serie_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
