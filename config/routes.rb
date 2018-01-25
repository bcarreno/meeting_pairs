Rails.application.routes.draw do
  get 'meeting/index', to: 'meeting#index'
  post 'meeting/randomize', to: 'meeting#randomize'
end
