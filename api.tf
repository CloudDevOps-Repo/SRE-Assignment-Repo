
resource "aws_api_gateway_rest_api" "apiLambda" {
  name        = "Dice_Roll_Simulator_API"

    endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_lambda_permission" "apigw_permission_for_post_lambda" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.lambda.function_name
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_permission_for_get_lambda" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.lambda2.function_name
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/*/*"
}

resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
   path_part   = "dice-roll"
}

resource "aws_api_gateway_method" "proxyMethod" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "POST"
   authorization = "NONE"

     request_parameters = {
    "method.request.querystring.dice_sides"    = true
    "method.request.querystring.no_of_dices"    = true
    "method.request.querystring.no_of_simulations"    = true
  }
}

resource "aws_api_gateway_integration" "post_lambda" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_method.proxyMethod.resource_id
   http_method = aws_api_gateway_method.proxyMethod.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.lambda.invoke_arn
}

##############GET Method#################
resource "aws_api_gateway_resource" "roll_sim_result_get" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
   path_part   = "dice-roll-get-results"
}

resource "aws_api_gateway_method" "method_result_get" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.roll_sim_result_get.id
   http_method   = "POST"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_lambda" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_method.method_result_get.resource_id
   http_method = aws_api_gateway_method.method_result_get.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.lambda2.invoke_arn
}

resource "aws_api_gateway_method_response" "get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  resource_id = aws_api_gateway_resource.roll_sim_result_get.id
  http_method = aws_api_gateway_method.method_result_get.http_method
  status_code = "200"
    response_models = {
         "application/json" = "Empty"
    }
}


resource "aws_api_gateway_deployment" "apideploy_post" {
   
   depends_on = [
     aws_api_gateway_integration.get_lambda,
     aws_api_gateway_integration.post_lambda
   ]

   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   stage_name  = "dev"
}

resource "aws_api_gateway_deployment" "apideploy_get" {
   
   depends_on = [
     aws_api_gateway_integration.get_lambda,
     aws_api_gateway_integration.post_lambda
   ]
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   stage_name  = "dev"
}




