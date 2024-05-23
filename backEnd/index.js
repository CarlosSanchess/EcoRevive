import { initializeApp, applicationDefault } from "firebase-admin/app";
import { getMessaging } from "firebase-admin/messaging";
import { getAuth } from "firebase-admin/auth";
import express from "express";
import cors from "cors";
import admin from "firebase-admin";
import { readFileSync } from "fs";

const serviceAccount = JSON.parse(readFileSync("AdminSDK/vertical-prototype-70c6c-firebase-adminsdk-iuke3-8db1b39887.json"));
const PORT = 3000

const app = express();
app.use(express.json());
app.use(
    cors({origin: "*"}) //No specified origin
  );

initializeApp({
    credential: admin.credential.cert(serviceAccount),
    projectId: 'vertical-prototype-70c6c'
});

app.listen(
    PORT,
    () => console.log(`Its alive at port ${PORT}`)
)


app.post("/send", function (req, res) {

   if(!req.body.fcmToken){
      res.status(418).send({message:'Need to provide fcmToken'});
   }
    const receivedToken = req.body.fcmToken;
    const userName = req.body.userName;
    const bodyMessage = req.body.bodyMessage;
    
    const message = {
      notification: {
        title: `Received a Message from ${userName}.`,
        body: `${userName}: ${bodyMessage}`     
      },
      token: receivedToken,
    };
    
    getMessaging()
      .send(message)
      .then((response) => {
        res.status(200).json({
          message: `Successfully sent message, to device ${receivedToken}`,
        });
        console.log('Successfully sent message:', response);
      })
      .catch((error) => {
        res.status(400);
        res.send(error);
        console.log("Error sending message:", error);
      });
  });

  app.post("/sendRating", function (req, res) {

    if(!req.body.fcmToken){
       res.status(418).send({message:'Need to provide fcmToken'});
    }
     const receivedToken = req.body.fcmToken;
     const userName = req.body.userName;
     const bodyMessage = req.body.bodyMessage;
     
     const message = {
       notification: {
         title: `Received a Rating from ${userName}.`,
         body: `Rating:${bodyMessage}!`     
       },
       token: receivedToken,
     };
     
     getMessaging()
       .send(message)
       .then((response) => {
         res.status(200).json({
           message: `Successfully sent message, to device ${receivedToken}`,
         });
         console.log('Successfully sent message:', response);
       })
       .catch((error) => {
         res.status(400);
         res.send(error);
         console.log("Error sending message:", error);
       });
   });
   
app.post("/ban", function (req, res){

  if(!req.body.uid){
    res.status(418).send({message:'Need to provide uid'});
  }else{
      const receivedUID = req.body.uid;
        getAuth().deleteUser(receivedUID)
          .then(() => {
            console.log("User successfully banned.");
            res.status(200).json({
              reponse: `User successfully banned.`,
            });
          })
          .catch((error) => {
            console.error("Error banning user:", error);
            res.status(500).send(error);
          });
        }
});

app.post("/disable", function(req, res){

  if(!req.body.uid){
    res.status(418).send({message:'Need to provide uid'});
  }else{
    const receivedUID = req.body.uid;
    getAuth().updateUser(receivedUID,{
      disabled: true
    }).then(() => {
        console.log("User successfully disable.");
        res.status(200).json({
          reponse: `User successfully disable.`,
        });
      })
      .catch((error) => {
        console.error("Error banning user:", error);
        res.status(500).send(error);
      });
  }
});

app.post("/enable", function(req, res){

  if(!req.body.uid){
    res.status(418).send({message:'Need to provide uid'});
  }else{
    const receivedUID = req.body.uid;
    getAuth().updateUser(receivedUID,{
      disabled: false
    }).then(() => {
        console.log("User successfully enable.");
        res.status(200).json({
          reponse: `User successfully enable.`,
        });
      })
      .catch((error) => {
        console.error("Error banning user:", error);
        res.status(500).send(error);
      });
  }
});



function sendMessage(message){
  getMessaging().send(message)
    .then((response) => {
      console.log('Successfully sent message:', response);
    })
    .catch((error) => {
      console.log('Error sending message:', error);
    });
}
