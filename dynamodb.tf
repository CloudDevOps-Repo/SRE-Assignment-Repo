resource "aws_dynamodb_table" "dice_simulation_results" {
  name              = "Dice_Simulation_Results"
  read_capacity     = 5
  write_capacity    = 5
  hash_key          = "rowid"

  attribute {
    name = "rowid"
    type = "S"
  }

}