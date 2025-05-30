Rails.application.routes.draw do
  devise_for :users

  # Consider changing the root path to photos, or keep as users if preferred
  # root to: "users#index"
  root to: "photos#index" # Suggested new root

  # Standardized User routes
  resources :users, only: [:index, :show]
  # Old user routes (can be removed if you use the line above)
  # get("/users", { controller: "users", action: "index" })
  # get("/users/:id", { controller: "users", action: "show" })

  # Photo routes with nested Likes and Comments
  resources :photos do
    resources :likes, only: [:create, :destroy], shallow: true
    resources :comments, only: [:create] # Add other actions like :destroy if needed later
  end

  # --- KEEP THESE COMMENTED OUT OR DELETE THEM ---
  # Old Photo routes
  # # CREATE
  # #post("/insert_photo", { :controller => "photos", :action => "create" })
  # # READ
  # #get("/photos", { :controller => "photos", :action => "index" })
  # #get("/photos/:path_id", { :controller => "photos", :action => "show" })
  # # UPDATE
  # #post("/modify_photo/:path_id", { :controller => "photos", :action => "update" })
  # # DELETE
  # #get("/delete_photo/:path_id", { :controller => "photos", :action => "destroy" })

  # Old Like routes
  # # CREATE
  # #post("/insert_like", { :controller => "likes", :action => "create" })
  # # READ
  # #get("/likes", { :controller => "likes", :action => "index" })
  # #get("/likes/:path_id", { :controller => "likes", :action => "show" })
  # # UPDATE
  # #post("/modify_like/:path_id", { :controller => "likes", :action => "update" })
  # # DELETE
  # #get("/delete_like/:path_id", { :controller => "likes", :action => "destroy" })

  # Old Comment routes
  # # CREATE
  # #post("/insert_comment", { :controller => "comments", :action => "create" })
  # # READ
  # #get("/comments", { :controller => "comments", :action => "index" })
  # #get("/comments/:path_id", { :controller => "comments", :action => "show" })
  # # UPDATE
  # #post("/modify_comment/:path_id", { :controller => "comments", :action => "update" })
  # # DELETE
  # #get("/delete_comment/:path_id", { :controller => "comments", :action => "destroy" })
  # --- END OF COMMENTED OUT/DELETED ROUTES ---

  # Routes for the Follow request resource: (Leaving these as is for now)
  # CREATE
  post("/insert_follow_request", { :controller => "follow_requests", :action => "create" })
  # READ
  get("/follow_requests", { :controller => "follow_requests", :action => "index" })
  get("/follow_requests/:path_id", { :controller => "follow_requests", :action => "show" })
  # UPDATE
  post("/modify_follow_request/:path_id", { :controller => "follow_requests", :action => "update" })
  # DELETE
  get("/delete_follow_request/:path_id", { :controller => "follow_requests", :action => "destroy" })

  get "/users/:username/feed", to: "users#feed", as: "user_feed"

end
