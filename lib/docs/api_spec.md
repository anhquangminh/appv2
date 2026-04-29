# 🌐 API Specification – Evergreen Flutter App

## 1. Overview

Tài liệu này định nghĩa toàn bộ:
- API structure
- Request / Response format
- Error handling
- Authentication flow

Áp dụng cho:
- Clean Architecture
- Bloc state management
- Scalable backend integration

---

# 2. Base Configuration

## 2.1 Base URL


https://api.yourdomain.com/v1


---

## 2.2 Headers chuẩn

```http
Content-Type: application/json
Accept: application/json
Authorization: Bearer <access_token>
2.3 Timeout
Connect timeout: 30s
Receive timeout: 30s
3. Response Format (GLOBAL)
3.1 Success Response
{
  "success": true,
  "message": "Request successful",
  "data": {},
  "meta": {
    "page": 1,
    "limit": 10,
    "total": 100
  }
}
3.2 Error Response
{
  "success": false,
  "message": "Invalid request",
  "error_code": "INVALID_INPUT",
  "errors": {
    "email": ["Email is required"]
  }
}
4. Authentication APIs
4.1 Login
Endpoint
POST /auth/login
Request
{
  "email": "user@example.com",
  "password": "123456"
}
Response
{
  "success": true,
  "data": {
    "access_token": "jwt_token",
    "refresh_token": "refresh_token",
    "user": {
      "id": 1,
      "name": "User",
      "email": "user@example.com"
    }
  }
}
4.2 Refresh Token
POST /auth/refresh
4.3 Logout
POST /auth/logout
5. User APIs
5.1 Get Profile
GET /users/me
5.2 Update Profile
PUT /users/me
6. Pagination
Query Params
?page=1&limit=10
Meta Response
{
  "page": 1,
  "limit": 10,
  "total": 100
}
7. Error Codes
Code	Meaning
UNAUTHORIZED	Token invalid
FORBIDDEN	No permission
NOT_FOUND	Resource not found
VALIDATION_ERROR	Invalid input
SERVER_ERROR	Internal error
8. Networking Layer (Flutter)
8.1 Dio Setup
class ApiClient {
  final Dio dio;

  ApiClient(this.dio) {
    dio.options = BaseOptions(
      baseUrl: "https://api.yourdomain.com/v1",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    );
  }
}
8.2 Interceptors
dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      options.headers["Authorization"] = "Bearer token";
      return handler.next(options);
    },
    onError: (error, handler) {
      if (error.response?.statusCode == 401) {
        // refresh token logic
      }
      return handler.next(error);
    },
  ),
);
9. Repository Pattern
Domain Layer
abstract class AuthRepository {
  Future<User> login(String email, String password);
}
Data Layer
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<User> login(String email, String password) {
    return remote.login(email, password);
  }
}
10. Data Source
class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<User> login(String email, String password) async {
    final response = await dio.post("/auth/login", data: {
      "email": email,
      "password": password,
    });

    return User.fromJson(response.data["data"]["user"]);
  }
}
11. Model Mapping Rules
API → DTO → Entity
Không dùng DTO trực tiếp trong UI
12. Security Rules
Token lưu trong secure storage
Không log token
Refresh token tự động
13. Offline Handling
Cache response nếu cần
Retry khi mất mạng
14. API Versioning
/v1/
/v2/
15. Naming Convention
Endpoint
/users
/users/{id}
/users/me
JSON keys
snake_case (backend)
camelCase (Flutter mapping)
16. Best Practices
Không gọi API trong UI
Tất cả qua repository
Handle error ở Bloc
17. Flow tổng thể
UI → Bloc → UseCase → Repository → DataSource → API
``` id="flow_001"

---

# 18. Final Principle

> "API must be predictable, consistent, and easy to scale."