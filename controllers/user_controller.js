const User = require("../models/user");

exports.get_all_users = async (req, res, next) => {
  try {
    const users = await User.find();
    res.json(users);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

exports.get_user_by_id = async (req, res, next) => {
  const doesUserExist = await User.exists({_id: req.params.id});
  if(doesUserExist){
    try {
        const user = await User.findOne({_id: req.params.id})
        res.json(user)
    } catch (err) {
        res.status(500).json({message: err.message})
    }
} else {
    res.status(404).json({message: `user with ID of ${req.params.id} not found`})
}  
}

//patch request
//endpoint : /api/users/{id}/favourites - patch request
exports.update_user_favourites = (req, res, next) => {
  User.findOneAndUpdate(
    { _id: req.params.id },
    { $push: { favourites: req.body.dishId } },
    null,
    (err, result) => {
      if (err) {
        res.status(500).json({ message: err.message });
      } else {
        console.log(result);
        res.status(200).json({ message: "success" });
      }
    }
  );
};
