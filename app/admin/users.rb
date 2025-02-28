ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :username
  config.comments = false

  index do
    selectable_column
    id_column
    column :email  
    column :questions
    column :hits
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :username
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
