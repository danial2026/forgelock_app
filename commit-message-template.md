## Git Commit Message Template

```
<type>(<scope>): <short summary>

<optional body>

<optional footer>
```

### Example Breakdown:

1. **`<type>`**: Describes the nature of the change. Common types include:
   - `feat`: A new feature
   - `fix`: A bug fix
   - `chore`: Routine tasks, e.g., build process, dependencies
   - `docs`: Documentation changes
   - `style`: Code style changes (e.g., formatting, missing semicolons)
   - `refactor`: Code changes that neither fix a bug nor add a feature
   - `test`: Adding or fixing tests

2. **`<scope>`**: Optional, but useful to indicate the area of code affected. For example:
   - `auth`, `profile-service`, `gateway`, `docker`

3. **`<short summary>`**: A brief (imperative mood) description of the change.
   - Maximum 50 characters.
   - Should summarize the change clearly and concisely.

4. **`<optional body>`**: Additional details about the change (why and how).
   - Wrap text at 72 characters per line.
   - Useful for explaining the reason behind the change or important side effects.

5. **`<optional footer>`**: Any references to issues, breaking changes, or other extra notes.
   - Example: "Closes #123" or "BREAKING CHANGE: Changes the API structure"

### Example Commit Using the Template:

```
feat(auth): add token-based authentication

Implemented JWT-based authentication in the auth-service.
Updated routes to require token verification.

Closes #45
```

### Another Example (for a bug fix):

```
fix(profile-service): correct profile update bug

Resolved an issue where user profiles were not updating due to
a faulty database transaction. Added tests to cover edge cases.
```

### How to Use:

- Keep your commit messages short and informative.
- Write the subject line in **imperative mood** (e.g., "add", "fix", "update").
- Use the **body** to explain *why* the change was made if it's not obvious from the short summary.
