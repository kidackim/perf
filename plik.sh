function withDefaultTimeout(defaultTimeout: number) {
  return function (_target: any, _propertyKey: string, descriptor: PropertyDescriptor) {
    const originalMethod = descriptor.value;
    descriptor.value = async function (...args: any[]) {
      const options = args[1] || {};
      options.timeout = options.timeout ?? defaultTimeout;
      return originalMethod.apply(this, [args[0], options]);
    };
  };
}

class ApiService {
  @withDefaultTimeout(90000)
  async fetchData(url: string, options?: { timeout?: number }): Promise<any> {
    console.log(`Using timeout: ${options?.timeout}`);
    // Implement your async logic here
  }
}