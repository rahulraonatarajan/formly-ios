# Contributing to Formly iOS

Thank you for your interest in contributing to Formly iOS! This document provides guidelines and information for contributors.

## Code of Conduct

This project is committed to providing a welcoming and inclusive environment for all contributors. Please be respectful and considerate in all interactions.

## Getting Started

### Prerequisites
- Xcode 15.0 or later
- iOS 16.0+ deployment target
- macOS 14.0 or later
- Git

### Setup
1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/formly-ios.git`
3. Create a feature branch: `git checkout -b feature/your-feature-name`
4. Follow the setup instructions in [DEVELOPMENT.md](DEVELOPMENT.md)

## Development Guidelines

### Code Style
- Follow [Swift API Design Guidelines](https://www.swift.org/documentation/api-design-guidelines/)
- Use SwiftLint for code formatting
- Maximum line length: 120 characters
- Use trailing closures where appropriate

### Testing
- Write unit tests for all new functionality
- Ensure all tests pass before submitting
- Add UI tests for new user-facing features
- Maintain test coverage above 80%

### Documentation
- Add documentation comments for public APIs
- Update README.md if adding new features
- Include examples in documentation

### Commit Messages
Use conventional commit format:
```
type(scope): description

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Test changes
- `chore`: Build/tooling changes

Example:
```
feat(conversation): add support for DMV license renewal

- Add DMV template with validation rules
- Implement conversation flow for license renewal
- Add unit tests for validation logic

Closes #123
```

## Pull Request Process

1. **Create a feature branch** from `main`
2. **Implement your changes** following the guidelines above
3. **Write tests** for new functionality
4. **Update documentation** as needed
5. **Ensure all tests pass**
6. **Submit a pull request**

### Pull Request Checklist
- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] Documentation is updated
- [ ] No breaking changes (or clearly documented)
- [ ] Security implications considered
- [ ] Accessibility implemented
- [ ] Localization strings added

### Review Process
- All PRs require at least one review
- Address review comments promptly
- Maintainers may request changes
- PRs will be merged after approval

## Issue Reporting

### Bug Reports
Please include:
- iOS version
- Device model
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable
- Crash logs if available

### Feature Requests
Please include:
- Description of the feature
- Use case/justification
- Mockups if applicable
- Implementation suggestions

## Security

### Reporting Security Issues
- **DO NOT** create public issues for security vulnerabilities
- Email security issues to: security@formly.ai
- Include detailed description and steps to reproduce
- Allow time for investigation and fix

### Security Guidelines
- Never commit secrets or sensitive data
- Use secure coding practices
- Follow Apple's security guidelines
- Implement proper data protection

## Areas for Contribution

### High Priority
- Core conversation engine improvements
- Additional form templates
- Performance optimizations
- Accessibility enhancements
- Localization support

### Medium Priority
- UI/UX improvements
- Additional AI providers
- Enhanced backup/restore
- Advanced validation rules
- Testing improvements

### Low Priority
- Documentation improvements
- Code refactoring
- Tooling improvements
- Example projects

## Getting Help

- Check existing issues and PRs
- Review documentation in [DEVELOPMENT.md](DEVELOPMENT.md)
- Ask questions in discussions
- Join our community channels

## Recognition

Contributors will be recognized in:
- Repository contributors list
- Release notes
- Documentation acknowledgments

Thank you for contributing to Formly iOS!
