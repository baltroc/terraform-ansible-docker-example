<!DOCTYPE html>
<html lang="fr">
    <head>
        <meta charset="UTF-8">
        <title>Learn Docker with me</title>
    </head>

    <body>
        <h1>Learn Docker With me</h1>
        <form action="/index.php" method="post">
            <label for="something">give something:</label>
            <input type="text" id="something" name="something">
            <input type="submit" value="Submit">
        </form>
        <?php
          try {
              $connexion = new MongoDB\Driver\Manager( "mongodb://mymongodb:27017" );

              if (!empty($_POST)) {
                $bulk = new MongoDB\Driver\BulkWrite;
                $doc = ['_id' => new MongoDB\BSON\ObjectID, 'name' => $_POST['something']]; #not safe but it's only to do an example 
                $bulk->insert($doc);
                $connexion->executeBulkWrite('mydb.content', $bulk);
              }

              $query = new MongoDB\Driver\Query([]);
              $rows = $connexion->executeQuery("mydb.content", $query);

              foreach ($rows as $row) {
                  echo "$row->name<br/>";
              }
          } catch (MongoDB\Driver\Exception\Exception $e) {

            $filename = basename(__FILE__);

            echo "The $filename script has experienced an error.\n";
            echo "It failed with the following exception:\n";

            echo "Exception:", $e->getMessage(), "\n";
            echo "In file:", $e->getFile(), "\n";
            echo "On line:", $e->getLine(), "\n";
        }
        ?>
    </body>
</html>
