#!/usr/bin/env python3
import os
import subprocess
import requests
import json
import re
from typing import Optional

def get_staged_diff() -> Optional[str]:
    """获取当前 git stage 的 diff"""
    try:
        result = subprocess.run(
            ["git", "diff", "--cached"],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout if result.stdout.strip() else None
    except subprocess.CalledProcessError as e:
        print(f"Error getting git diff: {e}")
        return None

def clean_commit_message(message: str) -> str:
    """清理 commit message，移除不需要的前缀和格式"""
    # 移除可能的 Markdown 代码块标记
    message = message.replace('```', '').strip()
    # 移除行首的 "text" 或其他前缀
    message = re.sub(r'^\s*(text|commit|message):?\s*', '', message, flags=re.IGNORECASE)
    # 确保标题行符合 conventional commit 格式
    if not re.match(r'^(feat|fix|docs|style|refactor|test|chore)\(.*\):', message.split('\n')[0]):
        # 如果第一行不符合格式，尝试修复
        first_line = message.split('\n')[0]
        if ': ' in first_line:
            parts = first_line.split(': ', 1)
            message = f"feat(general): {parts[1]}\n" + '\n'.join(message.split('\n')[1:])
    return message.strip()

def generate_commit_message(diff: str, api_key: str) -> Optional[str]:
    """调用 DeepSeek API 生成 commit message"""
    url = "https://api.deepseek.com/v1/chat/completions"
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }
    
    prompt = (
        "基于以下 git diff 生成专业的 commit message。要求：\n"
        "1. 使用英文\n"
        "2. 严格遵循 conventional commit 格式\n"
        "3. 第一行标题格式: type(scope): description (不超过50字符)\n"
        "4. 空一行后添加详细说明，使用 bullet points (- 开头)\n"
        "5. 每个 bullet point 应具体描述一个变更\n"
        "6. 只返回最终的 commit message 内容，不要有任何前缀、解释或额外格式\n"
        "\n"
        "Git diff:\n"
        f"{diff}"
    )
    
    data = {
        "model": "deepseek-chat",
        "messages": [
            {
                "role": "user",
                "content": prompt
            }
        ],
        "temperature": 0.7,
        "max_tokens": 300
    }
    
    try:
        response = requests.post(url, headers=headers, json=data)
        response.raise_for_status()
        result = response.json()
        raw_message = result["choices"][0]["message"]["content"].strip()
        return clean_commit_message(raw_message)
    except Exception as e:
        print(f"Error calling DeepSeek API: {e}")
        return None

def git_commit(message: str) -> bool:
    """执行 git commit"""
    try:
        # 分割标题和正文
        lines = message.split('\n')
        title = lines[0]
        body = '\n'.join(lines[1:]).strip()
        
        if body:
            subprocess.run(
                ["git", "commit", "-m", title, "-m", body],
                check=True
            )
        else:
            subprocess.run(
                ["git", "commit", "-m", title],
                check=True
            )
        print("Successfully committed with message:")
        print(message)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error committing: {e}")
        return False

def main():
    # 1. 获取 staged diff
    diff = get_staged_diff()
    if not diff:
        print("No staged changes to commit.")
        return
    
    print("Found staged changes:")
    print(diff[:500] + "..." if len(diff) > 500 else diff)
    
    # 2. 从环境变量获取 API key
    api_key = os.getenv("DEEPSEEK_API_KEY")
    if not api_key:
        print("Please set DEEPSEEK_API_KEY environment variable")
        return
    
    # 3. 生成 commit message
    print("\nGenerating commit message...")
    commit_message = generate_commit_message(diff, api_key)
    if not commit_message:
        print("Failed to generate commit message")
        return
    
    print("\nGenerated commit message:")
    print(commit_message)
    
    # 4. 确认并提交
    confirm = input("\nCommit with this message? [y/N] ").strip().lower()
    if confirm == "y":
        git_commit(commit_message)
    else:
        print("Commit cancelled.")

if __name__ == "__main__":
    main()
