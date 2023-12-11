defmodule Web.Router do
  use Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  # autheticate user
  pipeline :auth do
    plug Web.Auth.Pipeline
    plug Web.Auth.SetAccount
  end

  scope "/api", Web do
    pipe_through :api

    get "/", Home.PageController, :show
    post "/auth/sessions", Auth.SessionController, :create

    post "/onboarding/organizer", Onboarding.OrganizerController, :create
  end

  scope "/api", Web do
    pipe_through [:api, :auth]

    resources "/users", Users.UsersController do
      resources "/courses", Courses.CoursesController
    end

    resources("/onboarding/institution_info", Onboarding.InstitutionInfoController,
      only: [:create, :update, :show]
    )

    get "/profile", Users.ProfileController, :show
    get "/auth/sessions", Auth.SessionController, :refresh_session
    delete "/auth/sessions", Auth.SessionController, :destroy
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: Web.Telemetry
    end
  end
end
