class ErrorHandler {
  static String getLocalizedErrorMessage(dynamic error, String language) {
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('socketexception') ||
        errorString.contains('network') ||
        errorString.contains('failed host lookup') ||
        errorString.contains('no address associated with hostname') ||
        errorString.contains('connection refused') ||
        errorString.contains('connection timed out') ||
        errorString.contains('software caused connection abort')) {
      return language == 'ar'
          ? 'يرجى التحقق من الاتصال بالإنترنت والمحاولة مرة أخرى.'
          : 'Please check your internet connection and try again.';
    }
    
    if (errorString.contains('timeout')) {
      return language == 'ar'
          ? 'انتهت مهلة الاتصال. يرجى التحقق من الاتصال بالإنترنت والمحاولة مرة أخرى.'
          : 'Connection timeout. Please check your internet connection and try again.';
    }
    
    if (errorString.contains('401') || errorString.contains('unauthorized')) {
      return language == 'ar'
          ? 'بيانات الاعتماد غير صحيحة. يرجى التحقق من معرف ومفتاح Moddakir.'
          : 'Invalid credentials. Please check your Moddakir ID and Key.';
    }
    
    if (errorString.contains('403') || errorString.contains('forbidden')) {
      return language == 'ar'
          ? 'غير مصرح لك بالوصول. يرجى التحقق من صلاحياتك.'
          : 'Access forbidden. Please check your permissions.';
    }
    
    if (errorString.contains('404') || errorString.contains('not found')) {
      return language == 'ar'
          ? 'الخدمة غير متوفرة حالياً. يرجى المحاولة لاحقاً.'
          : 'Service not available. Please try again later.';
    }
    
    if (errorString.contains('500') || errorString.contains('server error')) {
      return language == 'ar'
          ? 'خطأ في الخادم. يرجى المحاولة لاحقاً.'
          : 'Server error. Please try again later.';
    }
    
    return language == 'ar'
        ? 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.'
        : 'An unexpected error occurred. Please try again.';
  }
}
