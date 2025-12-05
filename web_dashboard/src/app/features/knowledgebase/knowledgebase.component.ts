import { Component, computed, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { NgIf, NgClass } from '@angular/common';
import { UiButtonComponent } from '../../shared/ui-button.component';
import { UiPillComponent } from '../../shared/ui-pill.component';

@Component({
  selector: 'app-knowledgebase',
  standalone: true,
  imports: [FormsModule, NgIf, NgClass, UiButtonComponent, UiPillComponent],
  templateUrl: './knowledgebase.component.html',
  styleUrls: ['./knowledgebase.component.scss']
})
export class KnowledgebaseComponent {
  contentValue = '# Heading\n\nWrite knowledgebase content here...';
  previewMode = signal(false);
  content = signal(this.contentValue);
  copied = signal(false);

  rendered = computed(() => this.simpleMarkdown(this.content()));

  toggleClass(active: boolean) {
    return [
      'px-4 py-2 rounded-lg border text-sm font-semibold transition',
      active
        ? 'bg-sky-500/15 border-sky-400/50 text-sky-100 shadow-[0_0_18px_rgba(56,189,248,0.25)]'
        : 'border-white/10 text-slate-200 hover:border-white/30 hover:text-white'
    ].join(' ');
  }

  saveDraft() {
    // For now just log; hook to backend later.
    console.log('Knowledgebase draft saved:', this.content());
  }

  async copy() {
    try {
      await navigator.clipboard.writeText(this.content());
      this.copied.set(true);
      setTimeout(() => this.copied.set(false), 1500);
    } catch {
      this.copied.set(false);
    }
  }

  clear() {
    this.contentValue = '';
    this.content.set('');
  }

  // Very light markdown renderer; preserves single newlines.
  simpleMarkdown(src: string): string {
    const escapeHtml = (s: string) =>
      s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

    let html = escapeHtml(src);
    html = html.replace(/^### (.*)$/gm, '<h3>$1</h3>');
    html = html.replace(/^## (.*)$/gm, '<h2>$1</h2>');
    html = html.replace(/^# (.*)$/gm, '<h1>$1</h1>');
    html = html.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
    html = html.replace(/\*(.*?)\*/g, '<em>$1</em>');
    html = html.replace(/`([^`]+)`/g, '<code>$1</code>');

    html = html.replace(/\n/g, '<br>');
    return html;
  }

  ngOnChanges() {
    this.content.set(this.contentValue);
  }

  ngDoCheck() {
    // Keep signal in sync with ngModel value
    if (this.content() !== this.contentValue) {
      this.content.set(this.contentValue);
    }
  }
}

