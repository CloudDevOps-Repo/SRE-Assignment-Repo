output "dice_simulator_get_results_url" {
  value = "${aws_api_gateway_deployment.apideploy_get.invoke_url}/dice-roll-get-results"
}


output "dice_post_roll_simulator_url" {
  value = "${aws_api_gateway_deployment.apideploy_post.invoke_url}/dice-roll"
}
