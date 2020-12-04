const fs = require("fs"); // require node file system
const rimraf = require("rimraf"); // require rm package
const request = require("request"); // require node js request
const newman = require("newman"); // require newman
const postman_collection_url =
  "https://raw.githubusercontent.com/clonne101/newman-training/main/space_x.json";
const postman_collection_name = "space_x.json";

// method responsible for obtaining our collection
function getCollectionFile(postman_collection_url, postman_collection_name) {
  return new Promise((resolve, reject) => {
    // check if postman collection json exist, if not download it
    fs.readFile("./" + postman_collection_name, function (err) {
      if (err) {
        // write to log
        console.log(
          postman_collection_name + " collection file not found, downloading..."
        );

        // get the file contents
        request(postman_collection_url, function (error, response, body) {
          if (!error && response.statusCode == 200) {
            // write to log
            console.log("Retrieved file successfully, saving...");

            // write to file
            fs.writeFile(postman_collection_name, body, function (fail) {
              if (fail) {
                console.log(fail);
                reject(fail);
              }

              // write to log
              console.log(postman_collection_name + " saved successfully!");
              resolve(true);
            });
          } else {
            console.log(err);
            reject(err);
          }
        });
      } else {
        // write to log
        console.log(postman_collection_name + " exist proceeding...");
        resolve(true);
      }
    });
  });
}

// promise declaration
const promises = [
  getCollectionFile(postman_collection_url, postman_collection_name),
];

// promise resolver
Promise.all(promises).then((result) => {
  if (result) {
    // add space
    console.log("\n");

    // remove reporter folder
    rimraf("./newman", function () {
      console.log("Old newman reporters removed successfully...");
    });

    // call newman.run to pass `options` object and wait for callback
    newman.run(
      {
        collection: require("./" + postman_collection_name),
        reporters: ["html", "csv", "json"],
      },
      function (err) {
        if (err) {
          throw err;
        }
        console.log("\nCollection run complete!\n");
      }
    );
  }
});
