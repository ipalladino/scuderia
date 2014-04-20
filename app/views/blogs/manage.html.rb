<table>
  <tr>
    <th>Title</th>
    <th>Body</th>
    <th>User</th>
    <th>Type</th>
    <th></th>
    <th></th>
    <th></th>
  </tr>

<% @blogs.each do |blog| %>
  <tr>
    <td><%= blog.title %></td>
    <td><%= blog.body %></td>
    <td><%= blog.user_id %></td>
    <td><%= blog.blogtype %></td>
    <td><%= link_to 'Show', blog %></td>
    <td><%= link_to 'Edit', edit_blog_path(blog) %></td>
    <td><%= link_to 'Destroy', blog, method: :delete, data: { confirm: 'Are you sure?' } %></td>
  </tr>
<% end %>
</table>

<br />

<%= link_to 'New Blog', new_blog_path %>
