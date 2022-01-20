defmodule CrunchBerry.Components.ModalTest do
  use CrunchBerry.ComponentCase

  import Phoenix.LiveView.Helpers

  alias CrunchBerry.Components.Modal

  defmodule FixtureComponent do
    use Phoenix.LiveComponent

    def render(assigns) do
      ~H"""
      <p>Hello</p>
      """
    end
  end

  describe "render/1" do
    test "applies classes" do
      modal_opts = [
        id: :modal,
        return_to: "/mumble",
        component: FixtureComponent,
        classes: %{
          component: "component-classes",
          container: "container-classes",
          background: "background-classes",
          cancel_icon: "cancel_icon-classes"
        },
        opts: %{}
      ]

      html = render_component(Modal, modal_opts)

      {:ok, doc} = Floki.parse_document(html)

      assert doc
             |> Floki.find("#modal")
             |> Floki.attribute("class") == ["component-classes"]

      assert doc
             |> Floki.find("#modal > div")
             |> Floki.attribute("class") == ["container-classes"]

      assert doc
             |> Floki.find("#modal > div > div")
             |> Floki.attribute("class") == ["background-classes"]

      assert doc
             |> Floki.find("#modal > div > div > div > a")
             |> Floki.attribute("class") == ["cancel_icon-classes"]
    end
  end
end
