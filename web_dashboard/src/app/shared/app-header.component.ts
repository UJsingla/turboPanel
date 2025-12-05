import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';

@Component({
  selector: 'app-header',
  standalone: true,
  imports: [RouterLink, RouterLinkActive],
  template: `
    <header class="shell-header">
      <div class="brand-block">
        <div class="brand-dot"></div>
        <div>
          <p class="eyebrow">Internal Tools</p>
          <h1>Support Ops</h1>
        </div>
      </div>

      <nav class="tabs">
        <a routerLink="/tickets" routerLinkActive="active" [routerLinkActiveOptions]="{ exact: true }">Tickets</a>
        <a routerLink="/knowledgebase" routerLinkActive="active">Knowledgebase</a>
        <a routerLink="/logs" routerLinkActive="active">Live Logs</a>
      </nav>

      <div class="top-status">
        <div>
          <p class="eyebrow">Dashboard</p>
          <h2>Messaging Ops Control</h2>
        </div>
        <span class="badge">Local</span>
      </div>
    </header>
  `,
  styles: [
    `
:host {
  display: block;
  position: sticky;
  top: 0;
  z-index: 50;
  backdrop-filter: blur(14px);
}
      .shell-header {
        display: grid;
        grid-template-columns: auto 1fr auto;
        align-items: center;
        gap: 20px;
        padding: 14px 18px;
        background: linear-gradient(180deg, rgba(2, 6, 23, 0.9), rgba(2, 6, 23, 0.7));
        border-bottom: 1px solid rgba(255, 255, 255, 0.06);
      }
      .brand-block {
        display: flex;
        align-items: center;
        gap: 12px;
      }
      .brand-dot {
        width: 14px;
        height: 14px;
        border-radius: 50%;
        background: radial-gradient(circle at 30% 30%, #22d3ee, #6366f1);
        box-shadow: 0 0 12px rgba(99, 102, 241, 0.7);
      }
      .eyebrow {
        text-transform: uppercase;
        letter-spacing: 0.12em;
        font-size: 11px;
        color: #94a3b8;
        margin: 0;
      }
      h1 {
        margin: 0;
        font-size: 20px;
        color: #e2e8f0;
      }
      .tabs {
        display: flex;
        gap: 18px;
        justify-content: center;
      }
      .tabs a {
        padding: 10px 16px;
        border-radius: 12px;
        color: #cbd5e1;
        text-decoration: none;
        font-weight: 700;
        transition: all 0.2s ease;
        border: 1px solid transparent;
      }
      .tabs a.active {
        background: linear-gradient(135deg, #6366f1, #22d3ee);
        color: #0b1021;
        box-shadow: 0 10px 30px rgba(34, 211, 238, 0.25);
      }
      .tabs a:hover {
        color: #e2e8f0;
        border-color: rgba(255, 255, 255, 0.1);
      }
      .top-status {
        display: flex;
        align-items: center;
        gap: 12px;
      }
      .top-status h2 {
        margin: 2px 0 0 0;
        font-size: 22px;
        color: #e2e8f0;
      }
      .badge {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 8px 14px;
        border-radius: 14px;
        border: 1px solid rgba(34, 211, 238, 0.4);
        background: rgba(34, 211, 238, 0.14);
        color: #c0f2ff;
        font-weight: 700;
      }
      @media (max-width: 900px) {
        .shell-header {
          grid-template-columns: 1fr;
          gap: 10px;
          align-items: start;
        }
        .tabs {
          justify-content: flex-start;
          overflow-x: auto;
          padding-bottom: 4px;
        }
        .top-status {
          justify-content: space-between;
        }
      }
    `
  ]
})
export class AppHeaderComponent {}

