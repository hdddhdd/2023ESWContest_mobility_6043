import { Routes, Route } from "react-router-dom";
import MainPage from "./pages/MainPage";
import VideoPage from "./pages/VideoPage.jsx";

export default function App() {
  return (
    <Routes>
      <Route path="/" element={<MainPage />} />
      <Route path="/video" element={<VideoPage />} />
    </Routes>
  );
}