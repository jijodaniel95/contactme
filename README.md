# ContactMe API

A simple REST API service for handling contact form submissions and sending them to Google Cloud PubSub.

## Requirements

* Ruby 3.3.0
* Rails 8.0.2
* Google Cloud PubSub account and credentials

## Setup

1. Clone the repository
2. Install dependencies:
   ```
   bundle install
   ```
3. Add your Google Cloud credentials to `config/your-key.json`
4. Start the server:
   ```
   rails server
   ```

## API Endpoints

### Create Contact

**Endpoint:** `POST /api/contacts`

**Request Parameters:**
- `full_name` or `fullName` (required): The full name of the contact
- `email` (required): The email address of the contact
- `subject` (required): The subject of the message
- `message` or `messageText` (required): The body of the message

**Success Response (200 OK):**
```json
{
  "status": "success",
  "message": "Message sent successfully"
}
```

**Error Responses:**
- 422 Unprocessable Entity: Validation errors
```json
{
  "status": "error",
  "errors": ["Name is required", "Email is required"]
}
```
- 500 Internal Server Error: Error publishing to PubSub
```json
{
  "status": "error",
  "message": "Error processing your message"
}
```

## Legacy Endpoint

For backward compatibility, the following endpoint is also supported:

**Endpoint:** `POST /contact/create`

This endpoint has the same parameters and responses as `POST /api/contacts`.

## Google Cloud PubSub

The API publishes messages to a PubSub topic named `contact-form` with the following payload structure:

```json
{
  "fullName": "John Doe",
  "email": "john@example.com",
  "subject": "Inquiry",
  "messageText": "Hello, I would like more information."
}
```
