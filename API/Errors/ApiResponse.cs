namespace API.Errors
{
    public class ApiResponse
    {
        public ApiResponse(int statusCode, string message = null)
        {
            StatusCode = statusCode;
            Message = message ?? GetDefaultMessageForStatusCode(statusCode);
        }

        public int StatusCode { get; set; }
        public string Message { get; set; }

        private string GetDefaultMessageForStatusCode(int statusCode)
        {
            return statusCode switch
            {
                400 => "You have made a bad request",
                401 => "You are not authorized",
                403 => "You are forbidden from doing this",
                404 => "Resource was not found",
                500 => "Well, This is unexpected. Error code:500. An Error has occurred, and we are working to fix the problem! We will be up and running shortly",
                _ => null
            };
        }
    }
}