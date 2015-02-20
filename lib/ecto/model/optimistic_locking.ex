defmodule Ecto.Model.OptimisticLocking do
  defmacro optimistic_locking(field) do
    quote bind_quoted: [field: field] do
			hook_name = :"optimistic_locking_#{field}"

      before_update hook_name
      before_delete hook_name

      defp unquote(hook_name)(%Ecto.Changeset{model: model} = changeset) do
        field = unquote(field)
        current = Map.fetch!(model, field)

        update_in(changeset.filters, &Map.put(&1, field, current))
        |> put_change(field, current + 1)
      end
    end
  end
end
