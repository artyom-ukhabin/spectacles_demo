Rails.application.routes.draw do
  resources :spectacles, only: %i[index create destroy]
end
