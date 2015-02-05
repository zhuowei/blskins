#define TITLE Copy skin from Desktop edition
#include "header.html"
<form action="/upload_desktop" method="post" enctype="multipart/form-data">
<table>
<tr>
<td>Desktop Username:</td><td><input type="text" name="name"></td>
</tr>
<tr>
<td><input type="submit" value="Upload"></td>
</tr>
</table>
<p>Desktop username must have the correct capitalization: If your username is "example", "Example" won't work.</p>
</form>
#include "footer.html"
