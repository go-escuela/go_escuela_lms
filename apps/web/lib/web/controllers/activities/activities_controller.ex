defmodule Web.Activities.ActivitiesController do
  use Web, :controller

  action_fallback Web.FallbackController

  import Web.Auth.AuthorizedPlug
  import Web.Plug.CheckRequest

  alias GoEscuelaLms.Core.Schema.Activity

  plug :permit_authorized when action in [:create]
  plug :load_course when action in [:create]
  plug :check_enrollment when action in [:create]
  plug :load_topic when action in [:create]

  @create_params %{
    name: [type: :string, required: true],
    activity_type: [type: :string, required: true, in: Activity.activity_types()],
    feedback: :string,
    enabled: :boolean
  }

  def create(conn, params) do
    topic = conn.assigns.topic

    with {:ok, valid_params} <- Tarams.cast(params, @create_params),
         {:ok, activity} <- create_activity(topic, params, valid_params) do
      render(conn, :create, %{activity: activity})
    end
  end

  defp create_activity(topic, params, valid_params) do
    Task.async(fn ->
      activity_type = valid_params |> get_in([:activity_type])

      create_valid_params = %{
        name: valid_params |> get_in([:name]),
        topic_id: topic.uuid,
        activity_type: activity_type,
        feedback: valid_params |> get_in([:feedback]),
        enabled: valid_params |> get_in([:enabled]) || false
      }

      case activity_type do
        "resource" ->
          resource = params |> get_in(["resource"])
          params = create_valid_params |> Map.merge(%{resource: resource})
          Activity.create_with_resource(params)

        _ ->
          Activity.create(create_valid_params)
      end
    end)
    |> Task.await()
  end
end
