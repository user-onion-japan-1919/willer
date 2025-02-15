document.addEventListener('DOMContentLoaded', () => {
  // ✅ Ajax成功時の処理
  document.addEventListener('ajax:success', (event) => {
    const detail = event.detail;
    alert('✅ ユーザー情報が更新されました！');
    console.log('更新結果:', detail);
    // 画面位置は維持される (リロードしない)
  });

  // ⚠️ Ajax失敗時の処理
  document.addEventListener('ajax:error', (event) => {
    alert('⚠️ ユーザー情報の更新に失敗しました。');
  });
});