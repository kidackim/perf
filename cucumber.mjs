export default {
  default: {
    require: ["./steps/*.ts"], // Lokalizacja plików z krokami
    paths: ["./features/*.feature"], // Lokalizacja plików .feature
    format: ["progress", "summary"],
    publishQuiet: true,
  },
};
