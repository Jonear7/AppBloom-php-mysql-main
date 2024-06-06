<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Room Information</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/fancybox/3.5.7/jquery.fancybox.min.css" />
<style>
  body {
    font-family: Arial, sans-serif;
    background: linear-gradient(135deg, #8e2de2, #4a00e0);
    color: #ffffff;
    margin: 0;
    padding: 0;
  }
  table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    background-color: rgba(255, 255, 255, 0.1);
  }
  th, td {
    padding: 10px;
    border: 1px solid rgba(255, 255, 255, 0.2);
    text-align: left;
  }
  th {
    background-color: rgba(255, 255, 255, 0.2);
    color: #ffffff;
    font-weight: bold;
    text-transform: uppercase;
  }
  td {
    color: #ffffff;
  }
  .popup-image {
    cursor: pointer;
    max-width: 100px; /* Adjust the maximum width as needed */
    height: auto;
    border-radius: 5px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }
</style>

</head>
<body>
<h1 style="text-align: center; padding: 20px 0;">Room Information</h1>
<table>
  <thead>
    <tr>
      <th>#</th>
      <th>Name</th>
      <th>Description</th>
      <th>Price</th>
      <th>Image</th>
    </tr>
  </thead>
  <tbody>
    <?php
    $i = 1;
    $conn = mysqli_connect("localhost", "root", "", "bloom");
    if (!$conn) {
      die("Connection failed: " . mysqli_connect_error());
    }
    $rows = mysqli_query($conn, "SELECT * FROM room");
    ?>
    <?php foreach ($rows as $row) : ?>
    <tr>
      <td><?php echo $i++; ?></td>
      <td><?php echo $row["name"]; ?></td>
      <td><?php echo $row["description"]; ?></td>
      <td>$<?php echo $row["price"]; ?></td>
      <td>
        <?php foreach (json_decode($row["image"]) as $image) : ?>
          <a href="uploads/<?php echo $image; ?>" data-fancybox="images">
            <img class="popup-image" src="uploads/<?php echo $image; ?>" alt="<?php echo $row["name"]; ?>">
          </a>
        <?php endforeach; ?>
      </td>
    </tr>
    <?php endforeach; ?>
  </tbody>
</table>
<br>
<a href="upload.php" style="text-align: center; display: block; color: #ffffff; text-decoration: none; font-size: 18px;">Upload Image</a>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/fancybox/3.5.7/jquery.fancybox.min.js"></script>
</body>
</html>
