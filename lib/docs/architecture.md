# 🏗️ Flutter Architecture – Evergreen Clean Architecture## 1. OverviewTài liệu này định nghĩa kiến trúc chuẩn cho ứng dụng Flutter:- Clean Architecture- Feature-first structure- Bloc state management- Scalable & maintainableMục tiêu:> Tách biệt rõ ràng giữa UI – Business Logic – Data---# 2. Architecture Layers## 2.1 Tổng quan
Presentation → Domain ← Data
---## 2.2 Layer Responsibilities### 1. Presentation LayerChứa:- UI (Screens, Widgets)- Bloc (State management)Không chứa:- Business logic phức tạp- API calls---### 2. Domain LayerChứa:- Entities- UseCasesĐặc điểm:- Pure Dart- Không phụ thuộc Flutter---### 3. Data LayerChứa:- API calls- Local storage- DTO models- Repository implementation---# 3. Folder Structure
lib/
│
├── core/
├── features/
├── shared/
├── data/
├── domain/
├── presentation/
---## 3.1 Feature-based Structure
features/
├── auth/
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   └── bloc/
---# 4. Data Flow
UI → Bloc → UseCase → Repository → DataSource → API
---# 5. Bloc Architecture## 5.1 Structure
auth/bloc/
├── auth_bloc.dart
├── auth_event.dart
├── auth_state.dart
---## 5.2 Bloc Rules✔ Bloc xử lý:- Business logic- State transitions❌ Bloc không gọi trực tiếp UI---## 5.3 State Pattern
Initial → Loading → Success → Failure
---# 6. UseCase Layer## 6.1 Purpose- Mỗi UseCase = 1 hành động- Tách logic ra khỏi Bloc---## 6.2 Example```dart id="usecase_001"class LoginUseCase {  final AuthRepository repository;  LoginUseCase(this.repository);  Future<User> call(String email, String password) {    return repository.login(email, password);  }}

7. Repository Pattern
7.1 Domain
abstract class AuthRepository {  Future<User> login(String email, String password);}

7.2 Data Implementation
class AuthRepositoryImpl implements AuthRepository {  final AuthRemoteDataSource remote;  AuthRepositoryImpl(this.remote);  @override  Future<User> login(String email, String password) {    return remote.login(email, password);  }}

8. Data Source Layer
8.1 Remote
class AuthRemoteDataSource {  final Dio dio;  AuthRemoteDataSource(this.dio);  Future<User> login(String email, String password) async {    final res = await dio.post('/auth/login', data: {      "email": email,      "password": password,    });    return User.fromJson(res.data["data"]);  }}

8.2 Local (Optional)


SharedPreferences


SecureStorage


SQLite



9. Entity vs Model
Entity (Domain)


Business object


Không phụ thuộc JSON


Model (Data)


Mapping từ API



10. Dependency Injection
10.1 Tools


get_it


injectable (optional)



10.2 Example
final getIt = GetIt.instance;void setup() {  getIt.registerLazySingleton(() => Dio());  getIt.registerLazySingleton(() => AuthRemoteDataSource(getIt()));  getIt.registerLazySingleton<AuthRepository>(    () => AuthRepositoryImpl(getIt()),  );}

11. Navigation Architecture
Options:


go_router (recommended)


auto_route



Example:
GoRoute(  path: "/login",  builder: (context, state) => LoginScreen(),)

12. Error Handling
Centralized Error System


ApiException


Failure (domain)


Bloc state mapping



13. UI Composition Rules


Small widgets


Reusable components


Stateless first



14. Scaling Strategy
Khi app lớn:


Tách feature rõ ràng


Không phụ thuộc chéo


Core giữ ổn định



15. Performance Strategy


Avoid rebuild toàn màn hình


BlocBuilder granular


const widgets



16. Testing Strategy
Unit Test


UseCase


Repository


Widget Test


UI components


Integration Test


End-to-end flow



17. Anti-Patterns (CẦN TRÁNH)
❌ Gọi API trong UI
❌ Business logic trong widget
❌ Dùng Model trong UI
❌ Shared logic lung tung

18. Golden Rules


UI chỉ hiển thị


Bloc xử lý state


UseCase xử lý logic


Repository là bridge


DataSource gọi API



19. Architecture Diagram (Mental Model)
[ UI ]   ↓[ Bloc ]   ↓[ UseCase ]   ↓[ Repository ]   ↓[ DataSource ]   ↓[ API / Local DB ]

20. Final Principle

"Code should be easy to change, not just easy to write."

---# 🚀 Nếu bạn muốn bước tiếp theoMình có thể giúp bạn build tiếp:### 🔥 Full production setup:- `base_bloc.dart`- `base_usecase.dart`- `failure.dart + error_handler.dart`- `app_router.dart`- `di.dart`### 🤖 Codex automation:- Prompt tạo feature auto theo architecture- Prompt convert UI → Bloc + Clean Architecture### 🧱 Hoặc:- Generate full Flutter boilerplate chạy ngay---👉 Chỉ cần nói: **“tạo full boilerplate theo architecture này”**