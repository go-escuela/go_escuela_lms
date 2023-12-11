alias GoEscuelaLms.Core.Schema.User
alias GoEscuelaLms.Core.Repo, as: Repo

# create Admin
case Repo.get_by(User, role: "organizer") do
  nil ->
    User.create(%{full_name: "Admin", email: "admin@example.com", role: "organizer", password_hash: "GoEscuelaOrganizer"})
  item ->
    item
end