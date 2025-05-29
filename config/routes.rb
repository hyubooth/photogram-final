Rails.application.routes.draw do
  
  devise_for :users
  root to: "users#index"
  

  #user routes
  get("/users", { controller: "users", action: "index" })
  get("/users/:id", { controller: "users", action: "show" })


  
  # Routes for the Follow request resource:

  # CREATE
  post("/insert_follow_request", { :controller => "follow_requests", :action => "create" })
          
  # READ
  get("/follow_requests", { :controller => "follow_requests", :action => "index" })
  
  get("/follow_requests/:path_id", { :controller => "follow_requests", :action => "show" })
  
  # UPDATE
  
  post("/modify_follow_request/:path_id", { :controller => "follow_requests", :action => "update" })
  
  # DELETE
  get("/delete_follow_request/:path_id", { :controller => "follow_requests", :action => "destroy" })

  #------------------------------

  # Routes for the Like resource:

  # CREATE
  #post("/insert_like", { :controller => "likes", :action => "create" })
          
  # READ
  #get("/likes", { :controller => "likes", :action => "index" })
  
  #get("/likes/:path_id", { :controller => "likes", :action => "show" })
  
  # UPDATE
  
  #post("/modify_like/:path_id", { :controller => "likes", :action => "update" })
  
  # DELETE
  #get("/delete_like/:path_id", { :controller => "likes", :action => "destroy" })

  #------------------------------

  # Routes for the Comment resource:

  # CREATE
  post("/insert_comment", { :controller => "comments", :action => "create" })
          
  # READ
  get("/comments", { :controller => "comments", :action => "index" })
  
  get("/comments/:path_id", { :controller => "comments", :action => "show" })
  
  # UPDATE
  
  post("/modify_comment/:path_id", { :controller => "comments", :action => "update" })
  
  # DELETE
  get("/delete_comment/:path_id", { :controller => "comments", :action => "destroy" })

  #------------------------------

  # Routes for the Photo resource:

  resources :photos do
    # --- ADD THIS NESTED ROUTE ---
    # This creates:
    # POST /photos/:photo_id/likes  (for liking)  -> photo_likes_path
    # DELETE /likes/:id             (for unliking) -> like_path
    resources :likes, only: [:create, :destroy], shallow: true
    # --- END ---

    # Add comments routes here too if needed
    resources :comments, only: [:create]
  end
  # CREATE
  #post("/insert_photo", { :controller => "photos", :action => "create" })
          
  # READ
  #get("/photos", { :controller => "photos", :action => "index" })
  
  #get("/photos/:path_id", { :controller => "photos", :action => "show" })
  
  # UPDATE
  
  #post("/modify_photo/:path_id", { :controller => "photos", :action => "update" })
  
  # DELETE
  #get("/delete_photo/:path_id", { :controller => "photos", :action => "destroy" })

 

  #------------------------------
  
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  # root "articles#index"
  # Add below other routes


  
end
